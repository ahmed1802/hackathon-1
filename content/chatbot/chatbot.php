// This is a testcto call gpt 3.5 turbo API (not working yet)
<?php
$apiKey = 'Ysk-proj-fTVBlIsjrmMPtO98JTkKRt5jFskB-x-54sDR4tZuHo7TwzKQGsew6c9vrtWx4iqlQvx7eqG91mT3BlbkFJs2qqDg3wdbcs1B1vIZcN1FvhI1ANjyVB8WI_zctupEGf8Rr0dEZdAsQ-RiZxwjXt63leUsqOsA';  // replace this with your actual API key
$inputText = $_POST['message'] ?? '';

$data = [
    'model' => 'gpt-3.5-turbo',
    'messages' => [
        ['role' => 'system', 'content' => 'You are a helpful language tutor. Correct grammar and explain.'],
        ['role' => 'user', 'content' => $inputText]
    ]
];

$ch = curl_init('https://api.openai.com/v1/chat/completions');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Authorization: Bearer ' . $apiKey
]);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));

$response = curl_exec($ch);
curl_close($ch);

$result = json_decode($response, true);
echo json_encode(['reply' => $result['choices'][0]['message']['content']]);
?>
