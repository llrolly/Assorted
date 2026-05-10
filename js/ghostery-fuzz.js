// Basic fuzzing for ghostery URL parser.
// https://www.npmjs.com/package/@ghostery/url-parser
// Fuzzing with jazzer.js
// Ran for over 1,073,741,824 executions
// Found 3 timeouts & 3 slow units

module.exports.fuzz = function (data) {

    try {
        const parsed = new URL(data.toString());
        parsed.hostname // == 'www.example.com'
        } catch(e) {
            if (e.message.indexOf('Invalid URL') !== -1 ||
                e.message.indexOf('Failed to') !== -1 ) {
            } else {
                throw e;
            }
        }

};
