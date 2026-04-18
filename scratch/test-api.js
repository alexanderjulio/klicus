import http from 'http';

function checkSession() {
  http.get('http://localhost:4000/api/auth/session', (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
      console.log('Status Code:', res.statusCode);
      console.log('Content-Type:', res.headers['content-type']);
      console.log('Body Preview:', data.substring(0, 100));
      if (data.includes('<!DOCTYPE')) {
        console.error('ERROR: Received HTML instead of JSON!');
      } else {
        console.log('SUCCESS: Received JSON (likely).');
      }
    });
  }).on('error', (err) => {
    console.error('Fetch Error:', err.message);
  });
}

checkSession();
