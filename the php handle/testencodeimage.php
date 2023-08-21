<?php

$imagePath = '851855.jpg'; // Replace with the actual path to your image file

$imageData = file_get_contents($imagePath);

$base64Image = base64_encode($imageData);

$img_ata = base64_decode($base64Image);

echo $base64Image;
echo $img_ata;
