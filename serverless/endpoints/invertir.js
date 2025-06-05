module.exports.invertir = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hola desde Invertir!" }),
  };
};
