<?php

$imagePath = '851855.jpg'; // Replace with the actual path to your image file

// Read the image file
$imageData = file_get_contents($imagePath);

// Encode the image data to Base64
$base64Image = base64_encode($imageData);

$img_ata = base64_decode($base64Image);

// Display the Base64-encoded image data
echo $base64Image;
echo $img_ata;
