// Refactoring Challenge #1
// Convert this legacy JavaScript code to modern TypeScript
// Time to beat: 3 minutes

function getUserData(callback) {
    $.ajax({
        url: '/api/users',
        success: function(data) {
            var users = [];
            for(var i = 0; i < data.length; i++) {
                users.push({
                    name: data[i].name,
                    age: parseInt(data[i].age),
                    active: data[i].status === 'active'
                });
            }
            callback(null, users);
        },
        error: function(xhr, status, err) {
            callback(err);
        }
    });
}

// Your modern TypeScript solution here... 