const xhr = new XMLHttpRequest();

const img = document.querySelector('.img');
const title = document.querySelector('.picture-title');
const text = document.querySelector('.picture-text');
const create_day = document.querySelector('.create-day');
const picture_id = new URL(location.href).searchParams.get('id');

img.src = `/api/get-img?id=${picture_id}`;

console.log(`Picture id: ${picture_id}`);
xhr.open('GET', `/api/get-img-info?id=${picture_id}`);
xhr.send();

xhr.onloadend = (() => {
    const response_str = xhr.responseText;
    console.log(response_str);
    if (response_str == 'False') {
        swal.fire('Error', 'そのような画像は存在しません');
        location.href = '/';
        return;
    } else {
        const response = JSON.parse(response_str);
        title.innerText = response['title'];
        text.innerText = response['text'];
        create_day.innerText = response['create_day'];
        return;
    }
});