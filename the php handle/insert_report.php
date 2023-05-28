<?php

// Define your Server host name here.
$HostName = "localhost";

// Define your MySQL Database Name here.
$DatabaseName = "itsla_maintenance";

// Define your Database User Name here.
$HostUser = "root";

// Define your Database Password here.
$HostPass = "";

// Creating MySQL Connection.
$con = mysqli_connect($HostName, $HostUser, $HostPass, $DatabaseName);

$lokasi = $_POST['lokasi'];
$gerbang = $_POST['gerbang'];
$pesan = $_POST['pesan'];
$status = $_POST['status'];
$email = $_POST['email'];

// Retrieve the id_user based on email
$selectUserQuery = "SELECT id FROM user WHERE email = '$email'";
$result = mysqli_query($con, $selectUserQuery);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $id_user = $row['id'];

    // Check if img_content file was uploaded successfully
    if (isset($_FILES['img_content']) && $_FILES['img_content']['error'] === UPLOAD_ERR_OK) {
        $img_content = $_FILES['img_content'];

        // Specify the directory to save the img_content
        $imageDirectory = 'before_maintenance/';

        // Generate a unique file name for the img_content
        $imageFileName = uniqid() . '_' . $img_content['name'];

        // Path to save the img_content on the server
        $imagePath = $imageDirectory . $imageFileName;

        // Move the uploaded img_content to the specified directory
        if (move_uploaded_file($img_content['tmp_name'], $imagePath)) {
            // Prepare the insert statement
            $insertQuery = "INSERT INTO report (lokasi, gerbang, pesan, status, id_user, img_content)
                            VALUES ('$lokasi', '$gerbang', '$pesan', '$status', '$id_user', '$imagePath')";

            // Execute the insert query
            if (mysqli_query($con, $insertQuery)) {
                // Create the response array
                $response = array("status" => "success", "message" => "Data inserted successfully.");
            } else {
                // Error occurred while executing the insert query
                $response = array("status" => "error", "message" => "Error: " . mysqli_error($con));
            }
        } else {
            // Failed to move the uploaded img_content
            $response = array("status" => "error", "message" => "Failed to move the uploaded img_content.");
        }
    } else {
        // No img_content file uploaded or error occurred during upload
        $response = array("status" => "error", "message" => "No img_content file uploaded or error occurred during upload.");
    }
} else {
    // User not found
    $response = array("status" => "error", "message" => "User not found.");
}

// Convert the response array to JSON format
echo json_encode($response);

// Close the database connection
mysqli_close($con);

?>
