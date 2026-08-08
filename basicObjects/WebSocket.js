// websocket-server.js
import { WebSocketServer } from 'ws';
import { ChatHandler } from '../businessObjects/ChatHandler.js';
const clients = new Map();
const waitingMessages = new Map();

function createWebSocketServer(server) {
    const chatHandler = new ChatHandler();
    const wss = new WebSocketServer({ server });

    wss.on('connection', (ws, req) => {
        const session = req.session;
        console.log(session);

        const userId = session?.user || null;

        if (!session || !userId) {
            console.log('No autenticado, cerrando conexión WebSocket');
            ws.send(JSON.stringify({
                type: 'error',
                message: 'No autenticado'
            }));
            ws.close();
            return;
        }

        clients.set(userId, { ws, userId });

        console.log(`Cliente ${userId} conectado`);

        ws.send(JSON.stringify({
            type: 'connected',
            clientId: userId
        }));

        if (waitingMessages.has(userId)) {
            const pendingMessages = waitingMessages.get(userId);
            pendingMessages.forEach((msg) => {
                ws.send(JSON.stringify({
                    type: 'private',
                    from: msg.from,
                    content: msg.content,
                    isImage: msg.isImage,
                    timestamp: msg.timestamp
                }));
            });
            waitingMessages.delete(userId);
        }

        ws.on('message', (data) => {
            try {
                const message = JSON.parse(data);
                const receiver = message.receiver;
                const content = message.content;
                const sender = userId;
                const isImage = message.isImage || false;

                if (!receiver || !content) {
                    ws.send(JSON.stringify({
                        type: 'error',
                        message: 'receiver y content son requeridos'
                    }));
                    return;
                }

                const receiverClient = clients.get(receiver);

                if (!receiverClient) {
                    if (!waitingMessages.has(receiver)) {
                        waitingMessages.set(receiver, []);
                    }

                    waitingMessages.get(receiver).push({
                        from: sender,
                        content,
                        isImage: isImage,
                        timestamp: Date.now()
                    });

                    if (isImage) {
                        chatHandler.sendImage({ userSession: sender, userReceiver: receiver, image: content });
                    } else {
                        chatHandler.sendMessage({ userSession: sender, userReceiver: receiver, message: content });
                    }

                    ws.send(JSON.stringify({
                        type: 'info',
                        message: 'Cliente destino no conectado. Mensaje guardado para entrega futura.'
                    }));
                    return;
                }

                receiverClient.ws.send(JSON.stringify({
                    type: 'private',
                    isImage: isImage,
                    from: sender,
                    content,
                    timestamp: Date.now()
                }));

                ws.send(JSON.stringify({
                    type: 'sent',
                    to: receiver,
                    content,
                    timestamp: Date.now()
                }));
            } catch (error) {
                console.error('Error procesando mensaje:', error);
                ws.send(JSON.stringify({
                    type: 'error',
                    message: 'Error procesando mensaje'
                }));
            }
        });

        ws.on('close', () => {
            console.log(`Cliente ${userId} desconectado`);
            clients.delete(userId);
        });
    });

    return wss;
}

export default createWebSocketServer;