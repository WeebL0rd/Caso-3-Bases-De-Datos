module.exports.configurarVotacion = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hola desde config!" }),
  };
};
