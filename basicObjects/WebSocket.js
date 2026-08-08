import { WebSocketServer, WebSocket } from 'ws';
import { ChatHandler } from '../businessObjects/ChatHandler.js';
const clients = new Map();
const waitingMessages = new Map();

function createWebSocketServer(server, session) {
    const chatHandler = new ChatHandler();
    const wss = new WebSocketServer({ noServer: true });

    server.on('upgrade', (req, socket, head) => {
        session(req, {}, () => {
            if (!req.session || !req.session.user) {
                socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n');
                socket.destroy();
                return;
            }

            wss.handleUpgrade(req, socket, head, (ws) => {
                wss.emit('connection', ws, req);
            });
        });
    });

    wss.on('connection', (ws, req) => {
        const session = req.session;
        const userId = String(session?.user || '');

        if (!session || !userId) {
            console.log('No autenticado, cerrando conexión WebSocket');
            ws.send(JSON.stringify({ type: 'error', message: 'No autenticado' }));
            ws.close();
            return;
        }

        clients.set(userId, { ws, userId });

        console.log(`Cliente ${userId} conectado`);

        ws.send(JSON.stringify({ type: 'connected', clientId: userId }));

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

        ws.on('message', async (data) => {
            try {
                const message = JSON.parse(data);
                const receiver = String(message.receiver || '').trim();
                const content = message.content;
                const sender = userId;
                const isImage = Boolean(message.isImage);

                if (!receiver || !content) {
                    ws.send(JSON.stringify({
                        type: 'error',
                        message: 'receiver y content son requeridos'
                    }));
                    return;
                }

                const receiverClient = clients.get(receiver);
                const receiverConnected = receiverClient?.ws?.readyState === WebSocket.OPEN;

                if (!receiverConnected) {
                    clients.delete(receiver);

                    const pending = waitingMessages.get(receiver) || [];
                    pending.push({
                        from: sender,
                        content,
                        isImage,
                        timestamp: Date.now()
                    });
                    waitingMessages.set(receiver, pending);

                    try {
                        if (isImage) {
                            await chatHandler.sendImage({ userSession: sender, userReceiver: receiver, image: content });
                        } else {
                            await chatHandler.sendMessage({ userSession: sender, userReceiver: receiver, message: content });
                        }
                    } catch (sendError) {
                        console.error('Error guardando mensaje offline:', sendError);
                        ws.send(JSON.stringify({ type: 'error', message: 'Error guardando mensaje para entrega futura.' }));
                        return;
                    }

                    ws.send(JSON.stringify({
                        type: 'info',
                        message: 'Cliente destino no conectado. Mensaje guardado para entrega futura.'
                    }));
                    return;
                }

                try {
                    receiverClient.ws.send(JSON.stringify({
                        type: 'private',
                        isImage,
                        from: sender,
                        content,
                        timestamp: Date.now()
                    }));
                } catch (sendError) {
                    console.error('Error enviando al receptor:', sendError);
                    ws.send(JSON.stringify({ type: 'error', message: 'No se pudo entregar el mensaje.' }));
                    return;
                }

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