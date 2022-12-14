<!-- HTML -->
//<canvas id="matrix-canvas"></canvas>

<!-- JavaScript -->
<script>
  // Get the canvas element
  const canvas = document.getElementById('matrix-canvas');
  // Set the canvas to full screen
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  // Get the canvas context
  const ctx = canvas.getContext('2d');
  // Set the font and text baseline
  ctx.font = '20px monospace';
  ctx.textBaseline = 'middle';
  // Set the characters to use for the matrix rain
  const matrixChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@#$%^&*()_+-=[]{}|;:\'",.<>?/~`';
  // Set the number of columns and rows
  const columns = canvas.width / 20;
  const rows = canvas.height / 20;
  // Create an array to store the drops
  const drops = [];
  // Initialize the drops
  for (let i = 0; i < columns; i++) {
    drops[i] = 1;
  }
  // Render the matrix rain
  function draw() {
    // Set the fill style to black
    ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
    // Fill the entire canvas with a rectangle
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    // Set the fill style to green
    ctx.fillStyle = '#0F0';
    // Loop through the drops
    for (let i = 0; i < drops.length; i++) {
      // Get the character to draw
      const text = matrixChars[Math.floor(Math.random() * matrixChars.length)];
      // Draw the character
      ctx.fillText(text, i * 20, drops[i] * 20);
      // Reset the drop position if it hits the bottom of the canvas
      if (drops[i] * 20 > canvas.height && Math.random() > 0.975) {
        drops[i] = 0;
      }
      // Increment the drop position
      drops[i]++;
    }
  }
  // Render the matrix rain every 33 milliseconds
  setInterval(draw, 33);
</script>
