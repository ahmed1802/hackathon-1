<?php
session_start();
require_once '../../database/connect.php';

// Check if form was submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get form data
    $username = sanitize_input($conn, $_POST['username']);
    $password = $_POST['password'];
    $remember = isset($_POST['remember']) ? true : false;
    
    // Check if input is email or username
    $sql = "SELECT user_id, username, email, password, first_name FROM users 
            WHERE username = ? OR email = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $username, $username);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 1) {
        $user = $result->fetch_assoc();
        
        // Verify password
        if (password_verify($password, $user['password'])) {
            // Set session variables
            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['first_name'] = $user['first_name'];
            
            // Update last login
            $update_sql = "UPDATE users SET last_login = NOW() WHERE user_id = ?";
            $update_stmt = $conn->prepare($update_sql);
            $update_stmt->bind_param("i", $user['user_id']);
            $update_stmt->execute();
            
            // Set remember me cookie if checked
            if ($remember) {
                $token = bin2hex(random_bytes(32));
                
                // Store token in cookie for 30 days
                setcookie('remember_token', $token, time() + (86400 * 30), '/');
                
                // Update user's remember token in database
                // Note: In a production environment, add a remember_token column to users table
            }
            
            // Redirect to dashboard
            header("Location: ../main/dashboard.php");
            exit;
        } else {
            $_SESSION['error'] = "Invalid password. Please try again.";
        }
    } else {
        $_SESSION['error'] = "User not found. Please check your username or email.";
    }
    
    // Redirect back to login page on error
    header("Location: login.php");
    exit;
}
?>
