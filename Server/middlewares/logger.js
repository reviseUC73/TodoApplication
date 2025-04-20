const fs = require('fs');
const path = require('path');

// สร้างโฟลเดอร์ logs ถ้ายังไม่มี
const logDirectory = path.join(__dirname, '../logs');
if (!fs.existsSync(logDirectory)) {
  fs.mkdirSync(logDirectory);
}

// ไฟล์สำหรับเก็บ logs
const accessLogStream = fs.createWriteStream(
  path.join(logDirectory, 'access.log'),
  { flags: 'a' }
);

// Middleware สำหรับ logging
const logger = (req, res, next) => {
  const start = Date.now();
  const originalEnd = res.end;
  
  // Override res.end method to capture response status
  res.end = function (chunk, encoding) {
    const responseTime = Date.now() - start;
    const log = {
      timestamp: new Date().toISOString(),
      method: req.method,
      url: req.originalUrl || req.url,
      status: res.statusCode,
      responseTime: `${responseTime}ms`,
      userAgent: req.headers['user-agent'],
      ip: req.ip || req.headers['x-forwarded-for'] || req.connection.remoteAddress,
    };
    
    // Log to console
    console.log(
      `[${log.timestamp}] ${log.method} ${log.url} ${log.status} - ${log.responseTime} - ${log.ip}`
    );
    
    // Log to file
    accessLogStream.write(
      `[${log.timestamp}] ${log.method} ${log.url} ${log.status} - ${log.responseTime} - ${log.ip}\n`
    );
    
    originalEnd.apply(res, arguments);
  };
  
  next();
};

// ฟังก์ชันสำหรับการ format log สวยงาม
const formatMessage = (log) => {
  return `[${log.timestamp}] ${log.method} ${log.url} ${log.status} - ${log.responseTime} - ${log.ip}`;
};

module.exports = logger; 