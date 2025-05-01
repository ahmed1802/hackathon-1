<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="login.css">
    <title>Login Page</title>
</head>

<body>
    <div class="wrapper">
        
        <form action="../backend/db.php">
            <h1>Login</h1>
            <div class="input-box">
                <input type="text" placeholder="Username" required>
                <i class='bx bxs-user' ></i>
            </div>
            <div class="input-box">
                <input type="password" placeholder="Password" required>
                <i class='bx bxs-lock-alt'></i>
            </div>

            <div class="remember-forget">
                <label for=""><input type="checkbox"> Remember Me</label>
                <a href="#">Forgot password?</a>

            </div>
            <button class="btn" type="submit">Login</button>
            <div class="register-link">
                <p>You dont have an account? <a href="#">Register</a></p>
            </div>


        </form>

    </div>

</body>

</html>
