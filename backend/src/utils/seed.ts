import { EstadoEquipamento, PrismaClient } from '@prisma/client';
import { hashPassword } from './hash'


const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando o seeder da base de dados...');

  // === TIPOS DE EQUIPAMENTO ===
  await prisma.tipo.createMany({
    data: [
      { nome: 'Informática' },
      { nome: 'Mobiliário' },
      { nome: 'Eletrónica' },
      { nome: 'Comunicação' },
    ],
  });

  // === FABRICANTES ===
  await prisma.fabricante.createMany({
    data: [
      { nome: 'HP' },
      { nome: 'Dell' },
      { nome: 'Lenovo' },
      { nome: 'LG' },
    ],
  });

  // === MARCAS ===
  await prisma.marca.createMany({
    data: [
      { nome: 'HP' },
      { nome: 'Samsung' },
      { nome: 'Acer' },
      { nome: 'Apple' },
    ],
  });

  // === DEPARTAMENTOS ===
  const departamentoTI = await prisma.departamento.create({
    data: {
      nome: 'Tecnologias de Informação',
      sigla: 'TI',
      dataActualizacao: new Date(),
    },
  });

  const departamentoAdm = await prisma.departamento.create({
    data: {
      nome: 'Administração',
      sigla: 'ADM',
      dataActualizacao: new Date(),
    },
  });

  // === SECÇÕES ===
  const seccaoInfra = await prisma.seccao.create({
    data: {
      nome: 'Infraestruturas',
      sigla: 'INF',
      idDepartamento: departamentoTI.idDepartamento,
      dataActualizacao: new Date(),
    },
  });

  const seccaoFinanceira = await prisma.seccao.create({
    data: {
      nome: 'Financeira',
      sigla: 'FIN',
      idDepartamento: departamentoAdm.idDepartamento,
      dataActualizacao: new Date(),
    },
  });

  // === RESPONSÁVEIS ===
  const responsavel1 = await prisma.responsavel.create({
    data: {
      nome: 'João Silva',
      idSeccao: seccaoInfra.idSeccao,
      dataActualizacao: new Date(),
    },
  });

  const responsavel2 = await prisma.responsavel.create({
    data: {
      nome: 'Maria Costa',
      idSeccao: seccaoFinanceira.idSeccao,
      dataActualizacao: new Date(),
    },
  });

  // === UTILIZADORES ===
  const adminPassword = await hashPassword('123456');

  const utilizador1 = await prisma.utilizador.create({
    data: {
      username: 'admin',
      password: adminPassword,
      idDepartamento: departamentoTI.idDepartamento,
    },
  });

  // === EQUIPAMENTOS ===
  const equipamento1 = await prisma.equipamento.create({
    data: {
      nome: 'Computador Portátil HP',
      modelo: 'ProBook 450 G8',
      numeroSerie: 'HP12345ABC',
      quantidade: 10,
      dataAquisicao: new Date('2023-01-15'),
      estado: EstadoEquipamento.EM_USO,
      valorEstimado: 1500.0,
      idTipo: 1,
      idFabricante: 1,
      idMarca: 1,
      idSeccao: seccaoInfra.idSeccao,
      idUtilizador: utilizador1.idUtilizador,
      idResponsavel: responsavel1.codResponsavel,
      dataActualizacao: new Date(),
    },
  });

  const equipamento2 = await prisma.equipamento.create({
    data: {
      nome: 'Impressora Laser Samsung',
      modelo: 'Xpress M2020W',
      numeroSerie: 'SAMS123XYZ',
      quantidade: 3,
      dataAquisicao: new Date('2022-07-10'),
      estado: EstadoEquipamento.EM_USO,
      valorEstimado: 500.0,
      idTipo: 3,
      idFabricante: 4,
      idMarca: 2,
      idSeccao: seccaoFinanceira.idSeccao,
      idUtilizador: utilizador1.idUtilizador,
      idResponsavel: responsavel2.codResponsavel,
      dataActualizacao: new Date(),
    },
  });

  // === AMORTIZAÇÃO ===
  await prisma.amortizacao.createMany({
    data: [
      {
        idEquipamento: equipamento1.idEquipamento,
        metodo: 'linear',
        tempoUtilAnos: 5,
        valorInicial: 1500.0,
        valorResidual: 100.0,
        valorAmortizado: 600.0,
        dataCalculo: new Date('2024-12-31'),
      },
      {
        idEquipamento: equipamento2.idEquipamento,
        metodo: 'linear',
        tempoUtilAnos: 3,
        valorInicial: 500.0,
        valorResidual: 50.0,
        valorAmortizado: 300.0,
        dataCalculo: new Date('2024-12-31'),
      },
    ],
  });

  console.log('✅ Seeder concluído com sucesso!');
}

main()
  .then(async () => await prisma.$disconnect())
  .catch(async (e) => {
    console.error('❌ Erro no seeder:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
