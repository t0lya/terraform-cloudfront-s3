exports.handler = (event, context, callback) => {
  const response = event.Records[0].cf.response;

  callback(null, response);
};
