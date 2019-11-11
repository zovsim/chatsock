<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
 <style>
     .chatbox {
          display: none;
     }
         .messages {
         background-color: cadetblue;
         width: 540px;
         padding: 20px;
     }

        .messages .msg {
        background-color: white;
         border-radius: 10px;
         margin-bottom: 10px;
         overflow: hidden;
     }

         .messages .msg .from {
         background-color: #339966;
         line-height: 30px;
         text-align: center;
         color: white;
     }

         .messages .msg .text {
         padding: 10px;
     }

         .textarea .msg {
         width: 540px;
         padding: 10px;
         resize: none;
         border: none;
         box-shadow: 2px 2px 5px 0 inset;
     }
    </style>

<head>
    <title>Title</title>
</head>
<body>
    <h1>ChatBox</h1>
     <div class="start">
         <label>
             <input type="text" class="username" placeholder="enter name..." >
         </label>
         <button id="start">start</button>
 </div>
 <div class="chatbox" >
      <div class="messages"></div>
 <div>
      <textarea class="msg"></textarea>
     </div>
</div>
</body> <script>
     let chatUnit = {
         init() {
             this.startbox = document.querySelector(".start");
             this.chatbox = document.querySelector(".chatbox");
             this.startBtn = document.querySelector("button");
             this.nameInput = this.startbox.querySelector("input");

             this.msgTextArea = this.chatbox.querySelector("textarea");
             this.chatMessageContainer = this.chatbox.querySelector(".message");
             this.bindEvents();
         },
         bindEvents() {
             this.startBtn.addEventListener("click", e => this.openSocket());
             this.msgTextArea.addEventListener("keydown", e => {
                 if (e.ctrlKey) {
                     e.preventDefault();
                     this.send(); }
             });
         },
         send() {
             this.sendMessage({
                 name: this.name,
                 text: this.msgTextArea.value
             })
         },

         OnOpenSock() {

         },
         onMessage(msg) {
             let msgBlock = document.createElement("div");
             msgBlock.className = "msg";
             let fromBlock = document.createElement("div");
             fromBlock.className = "from";
             fromBlock.innerText = msg.name;
             let textBlock = document.createElement("div");
             textBlock.className = "text";
             textBlock.innerText = msg.text;

             msgBlock.appendChild(fromBlock);
             msgBlock.appendChild(textBlock);

         },
         onClose() {
         },

         sendMessage(msg) {
             this.onMessage({name: "i am", text: msg.text});
             this.msgTextArea.value = "";
             this.ws.send(JSON.stringify(msg));
         },

         openSocket() {
             this.ws = new WebSocket("ws://localhost:8080/chatsock/chat");
             this.ws.onopen = () => this.OnOpenSock();
             this.ws.onmessage = (e) => this.onMessage(JSON.parse(e.data));
             this.ws.onclose = () => this.onClose();

             this.name = this.nameInput.value;
             this.startbox.style.display = "none";
             this.chatbox.style.display = "block";
         },
     };

     window.addEventListener("load", e=> chatUnit.init());

 </script>
</html>
