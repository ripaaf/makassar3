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

// Check if image file was uploaded successfully
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $image = $_FILES['image'];
    
    // Specify the directory to save the image
    $imageDirectory = 'before_maintenance/';
    
    // Generate a unique file name for the image
    $imageFileName = uniqid() . '_' . $image['name'];
    
    // Path to save the image on the server
    $imagePath = $imageDirectory . $imageFileName;
    
    // Move the uploaded image to the specified directory
    if (move_uploaded_file($image['tmp_name'], $imagePath)) {
        // Retrieve the id_user based on email
        $selectUserQuery = "SELECT id FROM user WHERE email = '$email'";
        $result = mysqli_query($con, $selectUserQuery);

        if (mysqli_num_rows($result) > 0) {
            $row = mysqli_fetch_assoc($result);
            $id_user = $row['id'];
            
            // Prepare the insert statement
            $insertQuery = "INSERT INTO report (lokasi, gerbang, pesan, status, id_user, img_content)
                            VALUES ('$lokasi', '$gerbang', '$pesan', '$status', $id_user, '$imagePath')";

            // Execute the insert query
            if (mysqli_query($con, $insertQuery)) {
                $response = array("status" => "success", "message" => "Data inserted successfully.");
            } else {
                $response = array("status" => "error", "message" => "Error: " . mysqli_error($con));
            }
        } else {
            $response = array("status" => "error", "message" => "User not found.");
        }
    } else {
        // Failed to move the uploaded image
        $response = array("status" => "error", "message" => "Failed to move the uploaded image.");
    }
} else {
    // No image file uploaded or error occurred during upload
    $response = array("status" => "error", "message" => "No image file uploaded or error occurred during upload.");
}

// Convert the response array to JSON format
echo json_encode($response);

// Close the database connection
mysqli_close($con);

?>
