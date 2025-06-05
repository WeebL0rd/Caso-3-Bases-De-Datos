module.exports.comentar = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hola desde Comentar!" }),
  };
};
