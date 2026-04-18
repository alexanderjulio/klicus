const http = require('http');

async function runTest() {
  const TOTAL_REQUESTS = 50;
  const CONCURRENT_BATCH = 10;
  
  console.log(`--- Starting API Stress Test: ${TOTAL_REQUESTS} requests to /api/admin/stats ---`);
  
  const startTime = Date.now();
  let completed = 0;
  let success = 0;
  let failed = 0;

  const makeRequest = () => {
    return new Promise((resolve) => {
      const req = http.get('http://localhost:4000/api/admin/stats', (res) => {
        if (res.statusCode === 200) success++;
        else failed++;
        completed++;
        resolve();
      });
      req.on('error', () => {
        failed++;
        completed++;
        resolve();
      });
    });
  };

  // Run in chunks
  for (let i = 0; i < TOTAL_REQUESTS; i += CONCURRENT_BATCH) {
    const batch = Array(Math.min(CONCURRENT_BATCH, TOTAL_REQUESTS - i)).fill().map(makeRequest);
    await Promise.all(batch);
    console.log(`Progress: ${completed}/${TOTAL_REQUESTS}...`);
  }

  const duration = Date.now() - startTime;
  console.log('\n--- Test Results ---');
  console.log(`Duration: ${duration}ms`);
  console.log(`Average: ${(duration / TOTAL_REQUESTS).toFixed(2)}ms per request`);
  console.log(`Success: ${success}`);
  console.log(`Failed: ${failed}`);
  console.log('--------------------\n');
}

runTest();
