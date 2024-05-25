const controller_box = document.querySelector('.controller');
const post_mode = document.querySelector('.post-mode');
const delete_mode = document.querySelector('.delete-mode');
const post_box = document.querySelector('.post-box');
const delete_box = document.querySelector('.delete-box');
const send = document.querySelector('.send');
console.log("Controller side::Session_id: " + session_id);

post_mode.addEventListener('click', () =>{
    controller_box.style = 'display: none;';
    post_box.style = 'display: block;';
});

send.addEventListener('click', () => {
    console.log('PUSH');
    const xhr = new XMLHttpRequest();
    const formData = new FormData();

    const title = document.querySelector('#Title').value;
    const text = document.querySelector('.text').value;
    const file = document.querySelector('.file').files[0];

    console.log(`title: ${title}\ntext: ${text}`);

    formData.append('session_id', session_id);
    formData.append('title', title);
    formData.append('text', text);
    formData.append('file', file);

    xhr.open("POST", '/api/post-image');
    xhr.send(formData);

    xhr.onloadend = (() => {
        alert(xhr.responseText);
    });
});

delete_mode.addEventListener('click', () =>{
    swal.fire("現在作成中です...", "現在作成中です\n少々お待ちください。");
    // controller_box.style = 'display: none;';
    // delete_box.style = 'display: block;';
});