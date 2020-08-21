const path = require("path");

const redirects = require("./redirects");

exports.handler = (event, context, callback) => {
  const { request } = event.Records[0].cf;
  const { uri, querystring } = request;

  const matchedRedirect = redirects.find((redirect) =>
    new RegExp(redirect.from, "i").test(uri)
  );

  if (matchedRedirect) {
    const redirectValue =
      matchedRedirect.to + (querystring ? `?${querystring}` : "");

    const response = {
      status: "301",
      statusDescription: "Moved Permanently",
      headers: {
        location: [
          {
            key: "Location",
            value: redirectValue,
          },
        ],
      },
    };

    callback(null, response);

    return;
  }

  // Make sure directory requests serve index.html
  const extension = path.extname(uri);
  const isDirectory = !(extension && extension.length);
  if (isDirectory) {
    request.uri += uri.endsWith("/") ? "index.html" : "/index.html";
  }

  callback(null, request);
};
