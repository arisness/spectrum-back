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
}