export class InteractionHandler {
    async getLiked(data) {
        try{
            const result = await runQuery([[queries.interaction.getLiked, [data.userSession]]]);
            return result.rows;
        }
        catch (error){
            logger.error(`Error fetching interactions: ${error}`);
            return 'Internal server error during fetching interactions.';
        }
    }

    async getDisliked(data) {
        try{
            const result = await runQuery([[queries.interaction.getDisliked, [data.userSession]]]);
            return result.rows;
        }
        catch (error){
            logger.error(`Error fetching interactions: ${error}`);
            return 'Internal server error during fetching interactions.';
        }
    }

    async addInteraction(data) {
        try{
            const result = await runQuery([[queries.interaction.addInteraction, [data.userSession, data.userReceiver, data.interactionType]]]);
            return 'Interaction added successfully.';
        }catch (error){
            logger.error(`Error adding interaction: ${error}`);
            return 'Internal server error during adding interaction.';
        }

    }

    async updateInteraction(data) {
        try{
            const result = await runQuery([[queries.interaction.updateInteraction, [data.interactionType, data.userSession, data.userReceiver]]]);
            return 'Interaction updated successfully.';
        }catch (error){
            logger.error(`Error updating interaction: ${error}`);
            return 'Internal server error during updating interaction.';
        }

    }

    async getUsers(data){
        try{
            const likedUsers = await this.getLiked(data);
            const dislikedUsers = await this.getDisliked(data);
            const result = await runQuery([[queries.interaction.getRandomUsers, [data.userSession, 10]]]);
            const allUsers = result.rows;

            // Combinar usuarios con interacción
            const interactedUsers = new Set([
                ...likedUsers.flatMap(user => 
                    user.fk_users_one === data.userSession ? [user.fk_users_two] : 
                    user.fk_users_two === data.userSession ? [user.fk_users_one] : []
                ),
                ...dislikedUsers.flatMap(user => 
                    user.fk_users_one === data.userSession ? [user.fk_users_two] : 
                    user.fk_users_two === data.userSession ? [user.fk_users_one] : []
                )
            ]);

            // Filtrar usuarios
            const filteredUsers = allUsers.filter(user => 
                user.users_name !== data.userSession && 
                !interactedUsers.has(user.users_name)
            );

            return filteredUsers;
        }
        catch (error){
            logger.error(`Error fetching users: ${error}`);
            return 'Internal server error during fetching users.';
        }
    }
}