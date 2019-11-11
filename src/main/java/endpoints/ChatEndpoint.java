package endpoints;

import coders.MessageDecoder;
import coders.MessageEncoder;
import entities.Message;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

@ServerEndpoint(value = "/chat", decoders =  {MessageDecoder.class },encoders = {MessageEncoder.class })
public class ChatEndpoint {
    private Session session = null;
    private static  List<Session> sessionList = new LinkedList<>();

    @OnOpen
    public void OnOpen(Session session) {
        this.session=session;
        sessionList.add(session);
    }
   @OnClose
    public void OnClose (Session session)  {
       sessionList.remove(session);
           }

     @OnError
    public void OnError (Session session, Throwable throwable)  {
        throwable.printStackTrace();
    }

     @OnMessage
    public void OnMessage  (Session session, Message msg)  {
        sessionList.forEach(s->{
            if (s ==this.session) return;
            try {
                s.getBasicRemote() .sendObject(msg);
            } catch (IOException | EncodeException e) {
                e.printStackTrace();
            }
        } );

     }
}
