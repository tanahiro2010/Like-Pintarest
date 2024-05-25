const content_box = document.querySelector('.grid-container');
(() => {
    const xhr = new XMLHttpRequest();

    // If this user logined, edit account to user dashboard
    const cookie = document.cookie;
    console.log("Cookie: {}".replace('{}', cookie));


    xhr.open('GET', '/api/get-images');
    xhr.send();

    xhr.onloadend = (() => {
        const response = xhr.responseText;
        console.log(response)
    });
});
