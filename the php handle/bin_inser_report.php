<?php

// Define your Server host name here.
$HostName = "localhost";

// Define your MySQL Database Name here.
$DatabaseName = "itsla_maintenance";

// Define your Database User Name here.
$HostUser = "root";

// Define your Database Password here.
$HostPass = "makassar3";

// Creating MySQL Connection.
$con = mysqli_connect($HostName, $HostUser, $HostPass, $DatabaseName);

// Getting the received JSON into $json variable.
$json = file_get_contents('php://input');

// Decoding the received JSON and store it into $obj variable.
$obj = json_decode($json, true);

$lokasi = $obj['lokasi'];
$gerbang = $obj['gerbang'];
$pesan = $obj['pesan'];
$status = $obj['status'];
$email = $obj['email'];

// Retrieve the image data
$img_content = $obj['img_content'];

// Decode the image data from base64 format
$img_data = base64_decode($img_content);

// Generate a unique file name for the image
$imageFileName = uniqid() . '.jpg';

// Specify the path to save the image on the server
$imagePath = 'before_maintenance/' . $imageFileName;

// Save the image to the server
if (file_put_contents($imagePath, $img_data)) {
    // Image saved successfully

    // Retrieve the id_user based on email
    $selectUserQuery = "SELECT id FROM user WHERE email = '$email'";
    $result = mysqli_query($con, $selectUserQuery);

    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $id_user = $row['id'];

        // Extract the file extension from the image content type
        $imageExtension = pathinfo($imagePath, PATHINFO_EXTENSION);

        // Generate a unique file name for the image with the original extension
        $imageFileName = uniqid() . '.' . $imageExtension;

        // Update the image path with the new filename
        $newImagePath = 'before_maintenance/' . $imageFileName;

        // Rename the file on the server
        if (rename($imagePath, $newImagePath)) {
            // Prepare the insert statement
            $insertQuery = "INSERT INTO report (lokasi, gerbang, pesan, status, id_user, img_content)
                            VALUES ('$lokasi', '$gerbang', '$pesan', '$status', $id_user, '$newImagePath')";

            // Execute the insert query
            if (mysqli_query($con, $insertQuery)) {
                $response = array("status" => "success", "message" => "Data inserted successfully.");
            } else {
                $response = array("status" => "error", "message" => "Error: " . mysqli_error($con));
            }
        } else {
            // Failed to rename the file
            $response = array("status" => "error", "message" => "Failed to rename the image file.");
        }
    } else {
        $response = array("status" => "error", "message" => "User not found.");
    }
} else {
    // Failed to save the image
    $response = array("status" => "error", "message" => "Failed to save the image.");
}


// Convert the response array to JSON format
echo json_encode($response);

// Close the database connection
mysqli_close($con);

?>
