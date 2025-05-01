<?php
session_start();
require_once '../../database/connect.php';

// Check if form was submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get form data
    $username = sanitize_input($conn, $_POST['username']);
    $first_name = sanitize_input($conn, $_POST['first_name']);
    $last_name = sanitize_input($conn, $_POST['last_name']);
    $email = sanitize_input($conn, $_POST['email']);
    $password = $_POST['password'];
    $confirm_password = $_POST['confirm_password'];
    
    // Validate password matching
    if ($password !== $confirm_password) {
        $_SESSION['error'] = "Passwords do not match";
        header("Location: register.php");
        exit;
    }
    
    // Check if username or email already exists
    $check_sql = "SELECT username, email FROM users WHERE username = ? OR email = ?";
    $check_stmt = $conn->prepare($check_sql);
    $check_stmt->bind_param("ss", $username, $email);
    $check_stmt->execute();
    $check_result = $check_stmt->get_result();
    
    if ($check_result->num_rows > 0) {
        $existing = $check_result->fetch_assoc();
        if ($existing['username'] === $username) {
            $_SESSION['error'] = "Username already exists. Please choose another one.";
        } else {
            $_SESSION['error'] = "Email already registered. Please use another email or login.";
        }
        header("Location: register.php");
        exit;
    }
    
    // Password hashing
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    
    // Insert user into database
    $sql = "INSERT INTO users (username, first_name, last_name, email, password) 
            VALUES (?, ?, ?, ?, ?)";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssss", $username, $first_name, $last_name, $email, $hashed_password);
    
    if ($stmt->execute()) {
        // Get the new user ID
        $user_id = $stmt->insert_id;
        
        // Set session variables
        $_SESSION['user_id'] = $user_id;
        $_SESSION['username'] = $username;
        $_SESSION['first_name'] = $first_name;
        
        // Redirect to dashboard
        header("Location: ../main/dashboard.php");
        exit;
    } else {
        $_SESSION['error'] = "Registration failed: " . $conn->error;
        header("Location: register.php");
        exit;
    }
}
?>
