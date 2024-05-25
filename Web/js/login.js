const button = document.querySelectorAll('.Sign-in-button')[0];
button.addEventListener('click', () => {
    console.log('Test');
    const formData = new FormData();
    const xhr = new XMLHttpRequest();
    const mail = document.querySelector('#mail');
    const pass = document.querySelector('#pass');

    formData.append('type', 'login');
    formData.append('mail', mail.value);
    formData.append('pass', pass.value);

    xhr.open('POST', '/api/account');
    xhr.send(formData);

    xhr.onloadend = (() => {
        const response = xhr.responseText;
        console.log(response)
        if (response == 'False') {
            swal.fire('Error', 'そのようなアカウントは登録されていません', 'error');
        } else {
            const cookie_data = `user=${encodeURIComponent(JSON.stringify(response))}`;
            console.log(cookie_data)
            document.cookie = cookie_data;
            // location.href = '/dashboard';
        }
    });
});