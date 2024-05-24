const action = document.querySelector('.Sign-up-button');

action.addEventListener('click', () =>{
    const mail = document.querySelector('.user-mail');
    const name = document.querySelector('.user-name');
    const pass = document.querySelector('.user-pass');
    const id = document.querySelector('.user-id')

    const xhr = new XMLHttpRequest();
    const formData = new FormData();
    xhr.open('POST', '/api/account');

    formData.append('type', 'signin');
    formData.append('name', name.value);
    formData.append('mail', mail.value);
    formData.append('pass', pass.value);
    formData.append('id', id.value)

    xhr.send(formData);

    xhr.onloadend = (() =>{
        const response = xhr.responseText;
        console.log(response);
        if (response == 'Used-email'){
            swal.fire('Error', 'そのメールアドレスは使われています', 'error');
        }else{
            document.querySelector('#login').click();
            swal.fire('Please login', 'ログインしてください');
        }
    });
});