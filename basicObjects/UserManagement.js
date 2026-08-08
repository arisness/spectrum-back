import {verifyTokens, removeToken} from '../passwordRecovery/tokenManager.js';

class UserManagement
{
    async getAllUsers() {
        const result = await runQuery([[queries.user.getAllUsers, []]]);
        return result.rows;
    }

    async addUser(data) {
        if (data.image) data.image = await supabaseManager.uploadImage(data.username, data.image, `${data.username}_profile_image`);
        const values = [
            data.username, 
            data.email, 
            data.password, 
            data.profile, 
            data.firstName, 
            data.lastName,
            data.image || null,
            data.description || null,
            data.birthday];
        await runQuery([[queries.user.registerUser, values]]);
    }
    async addGeneralUser(req, res){
        try{
            if (req.body.image) req.body.image = await supabaseManager.uploadImage(req.body.username, req.body.image, `${req.body.username}_profile_image`);
            const values = [
                req.body.username, 
                req.body.email, 
                req.body.password, 
                req.body.firstName, 
                req.body.lastName,
                req.body.image || null,
                req.body.description || null,
                req.body.birthday];
            const r = await runQuery([[queries.user.registerGeneralUser, values]]);
            return res.status(201).json({status: 'success', message: 'User registered successfully.'});
        }
        catch (error){
            logger.error(`Error during registration: ${error}`);
            return res.status(500).json({status: 'error', message: 'Internal server error during registration.'});
        }
    }
    
    /**
     * Checks user existence by email or username, returns false if user doesn't exist, otherwise returns an object with username and email
     * @param {string} emailOrUsername 
     * @returns {Promise<Object|boolean>}
     */
    async checkUser(emailOrUsername)
    {
        try
        {
            const r = await runQuery([[queries.user.verifyUser, [emailOrUsername]]]);
            if (r.rows.length > 0) return {username: r.rows[0].users_name, email: r.rows[0].users_email};
            else return false;
        }
        catch (error)
        {
            logger.error(error);
            return false;
        }
    }

    async resetPassword(req,res){
        const {token, password} = req.body;
        const result = await verifyTokens(token, password);
        if (result.sts === 'error') return res.status(404).json({status: result.sts, message: result.msg});

        const passwordCheck = await runQuery([[queries.user.verifyUser, [result.email]]]);
        if (password === passwordCheck.rows[0].users_password) return res.status(404).json({status: 'error', message: 'This is your current password.'});

        if (result.sts === 'success'){
            try{
                await runQuery([[queries.user.updatePassword, [password, result.email]]]);
                removeToken(result.resetTokenIndex, `Token ${token} deleted after successful password update.`);
                return res.status(200).json({status: 'success', message: 'Password updated successfully.'});
            }
            catch (error)
            {
                logger.error(error);
                return res.status(500).json({status: 'error', message: `Internal error while resetting password: ${error}`});
            } 
        } else return res.status(404).json({status: result.sts, message: result.msg});
    }

    async deleteUser(username) {await runQuery([[queries.user.deleteUser, [username]]]);}

    async getUser(username){
        const results = await runQuery([[queries.user.getUser, [username]]]);
        results.rows.users_birthday = results.rows.users_birthday.toISOString().split('T')[0];
        return results.rows;
    }
    async updateUserValues(req, res){
        if (sessionHandler.checkSession(req)){
            const options = ['name', 'email', 'first_name', 'last_name', 'image', 'description', 'birthday'];
            if(req.body.option == 0 || req.body.option == 1){
                const userChecked = await userManagement.getUser(req.body.value);
                if (userChecked.length > 0){
                    return res.status(400).json({status: 'error', message: `User already exists with this ${req.body.option === 0 ? 'username' : 'email'}.`});
                }
            }
            if(req.body.option == 4){
                if (req.body.value!=null) {
                    req.body.value = await supabaseManager.uploadImage(req.session.user, req.body.value, `${req.session.user}_profile_image`);
                } else {
                    const userData = await runQuery([[queries.user.getImageUser, [req.session.user]]]);
                    await supabaseManager.deleteImage(userData.rows[0].users_image);
                }
            }
            const query = queries.user.updateValue.replace('{{var}}', options[req.body.option]);
            try{
                await runQuery([[query, [req.body.value, req.session.user]]]);
                if (req.body.option == 0) req.session.user = req.body.value;
                return res.status(200).json({status: 'success', message: 'User information updated successfully.'});
            }
            catch (error)
            {
                logger.error(`Error updating user information: ${error}`);
                return res.status(500).json({status: 'error', message: 'Internal server error while updating user information.'});
            }
        }
        else return res.status(401).json({status: 'error', message: 'Unauthorized. Please log in to update your information.'});
    }
}

const userManagement = new UserManagement();
export default userManagement;