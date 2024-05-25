const content_box = document.querySelector('.grid-container');
const cookie = decodeURIComponent(document.cookie);
console.log(cookie);
if (cookie != "") {
    const xhr = new XMLHttpRequest();
    const formData = new FormData();
    const session_id = cookie.split('=')[1];

    formData.append('session_id', session_id);

    xhr.open('POST', '/api/session');
    xhr.send(formData);

    xhr.onloadend = (() => {
        const response = xhr.responseText;
        console.log(response);
        if (response != "False"){
            const user = JSON.parse(response);
            const mail = user['mail'];
            const name = user['name'];
            console.log(`mail: ${mail}\nname: ${name}`);
            
            document.querySelector('.account-button').style = 'display: none';
            document.querySelector('.account-menu').style = 'display: flex';
            document.querySelector('.icon').src = `/api/get-icon?id=${mail}`;
        }
    });
}

(() => {
    const xhr = new XMLHttpRequest();

    xhr.open('GET', '/api/get-images');
    xhr.send();

    xhr.onloadend = (() => {
        const response = xhr.responseText;
        console.log(response);
    });
});
