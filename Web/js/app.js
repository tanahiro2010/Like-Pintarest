const content_box = document.querySelector('.grid-container');
(() => {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/get-images');
    xhr.send();

    xhr.onloadend = (() => {
        const response = xhr.responseText;
        console.log(response)
    });
});
