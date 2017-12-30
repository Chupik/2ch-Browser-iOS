var element = document.createElement("meta");
element.setAttribute("name", "viewport");
element.setAttribute("content", "width=device-width");
document.head.appendChild(element);

window.external = {
    notify: message => {
        console.log(message);
        window.webkit.messageHandlers.recaptcha.postMessage(message);
    }
};
