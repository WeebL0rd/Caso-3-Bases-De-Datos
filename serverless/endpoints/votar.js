module.exports.votar = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hola desde votar!" }),
  };
};
