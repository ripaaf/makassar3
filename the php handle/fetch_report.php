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

// Prepare the select statement
$selectQuery = "SELECT * FROM report";

// Execute the select query
$result = mysqli_query($con, $selectQuery);

// Check if records exist
if (mysqli_num_rows($result) > 0) {
    $response = array();

    // Loop through each row
    while ($row = mysqli_fetch_assoc($result)) {
        // Store row data in an array
        $reportData = array(
            "id" => $row['id'],
            "lokasi" => $row['lokasi'],
            "gerbang" => $row['gerbang'],
            "pesan" => $row['pesan'],
            "status" => $row['status'],
            "date_reported" => $row['date_reported'],
            "id_user" => $row['id_user'],
            "img_content" => $row['img_content']
        );

        // Add row data to the response array
        $response[] = $reportData;
    }

    // Convert the response array to JSON format
    echo json_encode($response);
} else {
    $response = array("status" => "error", "message" => "No records found.");
    echo json_encode($response);
}

// Close the database connection
mysqli_close($con);

?>
