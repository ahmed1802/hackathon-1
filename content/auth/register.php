<?php
session_start();
// Redirect if already logged in
if(isset($_SESSION['user_id'])) {
    header("Location: ../main/dashboard.php");
    exit;
}

// Display error message if exists
$error_message = isset($_SESSION['error']) ? $_SESSION['error'] : "";
$_SESSION['error'] = "";
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="register.css">
    <title>Sign Up - Language Learning</title>
</head>

<body>
    <div class="container">
        <div class="logo">
            <img src="../../resources/image/owl_logo.png" alt="Language Owl">
            <h1>LanguageOwl</h1>
        </div>
        
        <div class="wrapper">
            <form action="process_register.php" method="POST">
                <h2>Create Account</h2>
                <p class="subtitle">Start your language journey today!</p>
                
                <?php if(!empty($error_message)): ?>
                    <div class="error-message"><?php echo $error_message; ?></div>
                <?php endif; ?>
                
                <div class="input-box">
                    <input type="text" name="username" placeholder="Username" required>
                    <i class='bx bxs-user'></i>
                </div>

                <div class="input-box">
                    <input type="text" name="first_name" placeholder="First Name" required>
                    <i class='bx bxs-user-detail'></i>
                </div>

                <div class="input-box">
                    <input type="text" name="last_name" placeholder="Last Name" required>
                    <i class='bx bxs-user-detail'></i>
                </div>

                <div class="input-box">
                    <input type="email" name="email" placeholder="Email" required>
                    <i class='bx bxs-envelope'></i>
                </div>

                <div class="input-box">
                    <input type="password" name="password" placeholder="Password" required>
                    <i class='bx bxs-lock-alt'></i>
                </div>

                <div class="input-box">
                    <input type="password" name="confirm_password" placeholder="Confirm Password" required>
                    <i class='bx bxs-lock-alt'></i>
                </div>

                <div class="terms">
                    <label><input type="checkbox" name="terms" required> I agree to the <a href="#">Terms of Service</a></label>
                </div>
                
                <button class="btn" type="submit">Create Account</button>
                
                <div class="login-link">
                    <p>Already have an account? <a href="login.php">Log in</a></p>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
