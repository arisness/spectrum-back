export class ChatHandler {
    async getMessages(data) {
        try{
            const result = await runQuery([[queries.chat.getMessages, [data.userSession, data.userSender]]]);
            return result.rows;
        }
        catch (error){
            logger.error(`Error fetching recipes: ${error}`);
            return 'Internal server error during fetching recipes.';
        }
    }

    async sendMessage(data) {
        try{
            const result = await runQuery([[queries.chat.sendMessage, [data.userSession, data.userReceiver, data.message]]]);
            return 'Message sent successfully.';
        }catch (error){
            logger.error(`Error sending message: ${error}`);
            return 'Internal server error during sending message.';
        }

    }

    async sendImage(data) {
        try{
            data.image = await supabaseManager.uploadImage(data.userSession, data.image, `${data.userSession}_${data.userReceiver}_${Date.now()}`);
            const result = await runQuery([[queries.chat.sendImage, [data.userSession, data.userReceiver, data.image]]]);
            return data.image;
        }catch (error){
            logger.error(`Error sending image: ${error}`);
            return 'Internal server error during sending image.';
        }
    }
}