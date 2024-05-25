const content_box = document.querySelector('.grid-container');
const cookie = decodeURIComponent(document.cookie);
if (cookie == "") {}
const user_obj = JSON.parse(cookie.split('=')[1]);
console.log(user_obj);

if (null);

(() => {
    const xhr = new XMLHttpRequest();

    // If this user logined, edit account to user dashboard



    xhr.open('GET', '/api/get-images');
    xhr.send();

    xhr.onloadend = (() => {
        const response = xhr.responseText;
        console.log(response)
    });
});
