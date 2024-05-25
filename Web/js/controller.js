const controller_box = document.querySelector('.controller');
const post_mode = document.querySelector('.post-mode');
const delete_mode = document.querySelector('.delete-mode');
const post_box = document.querySelector('.post-box');
const delete_box = document.querySelector('.delete-box');


post_mode.addEventListener('click', () =>{
    controller_box.style = 'display: none;';
    post_box.style = 'display: block;';

    const xhr = new XMLHttpRequest();
    const formData = new FormData();

    const title = document.querySelector('.title').value;
    const text = document.querySelector('.text').value;
    const file = document.querySelector('file').files[0];

    formData.append('session_id', session_id);
    formData.append('title', title);
    formData.append('text', text);
    formData.append('file', file);
});

delete_mode.addEventListener('click', () =>{
    controller_box.style = 'display: none;';
    delete_box.style = 'display: block;';
});