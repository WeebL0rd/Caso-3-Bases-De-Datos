module.exports.listarVotos = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hola desde listaVotos!" }),
  };
};
