import 'package:flutter/material.dart';
import '../../../models/prova_dto.dart';
import '../../../models/turma_dto.dart';
import '../../../models/disciplina_dto.dart';
import '../../../models/gabarito_dto.dart';
import '../../../models/bimestre.dart';
import '../../../services/api_service.dart';

class ProvaFormScreen extends StatefulWidget {
  final ProvaDTO? prova;
  final int professorId;

  const ProvaFormScreen({super.key, this.prova, required this.professorId});

  @override
  State<ProvaFormScreen> createState() => _ProvaFormScreenState();
}

class _ProvaFormScreenState extends State<ProvaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _tituloController;
  late TextEditingController _dataController;
  late TextEditingController _novaQuestaoNumeroController;
  late TextEditingController _novaQuestaoRespostaController;

  TurmaDTO? _selectedTurma;
  DisciplinaDTO? _selectedDisciplina;
  Bimestre? _selectedBimestre;
  DateTime? _selectedDate;

  List<TurmaDTO> _turmas = [];
  List<DisciplinaDTO> _disciplinas = [];
  List<GabaritoDTO> _gabarito = [];

  bool _isLoadingDropdowns = true;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.prova?.titulo ?? '');
    _novaQuestaoNumeroController = TextEditingController();
    _novaQuestaoRespostaController = TextEditingController();

    if (widget.prova != null) {
      _selectedDate = widget.prova!.data;
      _dataController = TextEditingController(
          text: "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}");
      _selectedBimestre = widget.prova!.bimestre;
      _gabarito = List.from(widget.prova!.gabarito);
    } else {
      _dataController = TextEditingController();
      _selectedDate = null;
    }

    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final fetchedTurmas = await _apiService.fetchTurmasAdmin();
      final fetchedDisciplinas = await _apiService.fetchDisciplinas(professorId: widget.professorId);

      setState(() {
        _turmas = fetchedTurmas;
        _disciplinas = fetchedDisciplinas;
        _isLoadingDropdowns = false;

        if (widget.prova != null) {
          _selectedTurma = _turmas.firstWhere(
                (t) => t.id == widget.prova!.turmaId,
          );
          _selectedDisciplina = _disciplinas.firstWhere(
                (d) => d.id == widget.prova!.disciplinaId,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingDropdowns = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  void _addQuestao() {
    if (_novaQuestaoNumeroController.text.isEmpty ||
        _novaQuestaoRespostaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha número e resposta da questão.')),
      );
      return;
    }

    final int numeroQuestao = int.parse(_novaQuestaoNumeroController.text);
    final String respostaCorreta = _novaQuestaoRespostaController.text.toUpperCase().trim();

    if (_gabarito.any((q) => q.numeroQuestao == numeroQuestao)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Questão $numeroQuestao já existe no gabarito.')),
      );
      return;
    }

    setState(() {
      _gabarito.add(GabaritoDTO(
        numeroQuestao: numeroQuestao,
        respostaCorreta: respostaCorreta,
      ));
      _gabarito.sort((a, b) => a.numeroQuestao.compareTo(b.numeroQuestao));
      _novaQuestaoNumeroController.clear();
      _novaQuestaoRespostaController.clear();
    });
  }

  void _removeQuestao(int index) {
    setState(() {
      _gabarito.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dataController.text =
        "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
      });
    }
  }

  Future<void> _saveProva() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_gabarito.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos uma questão ao gabarito.')),
      );
      return;
    }
    if (_selectedTurma == null || _selectedDisciplina == null || _selectedBimestre == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios da prova.')),
      );
      return;
    }

    ProvaDTO provaToSave;
    if (widget.prova == null) {
      provaToSave = ProvaDTO(
        titulo: _tituloController.text,
        data: _selectedDate!,
        turmaId: _selectedTurma!.id!,
        disciplinaId: _selectedDisciplina!.id!,
        bimestre: _selectedBimestre!,
        gabarito: _gabarito,
      );
      try {
        await _apiService.addProva(provaToSave);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prova adicionada com sucesso!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar prova: $e')),
        );
      }
    } else {
      provaToSave = ProvaDTO(
        id: widget.prova!.id,
        titulo: _tituloController.text,
        data: _selectedDate!,
        turmaId: _selectedTurma!.id!,
        disciplinaId: _selectedDisciplina!.id!,
        bimestre: _selectedBimestre!,
        gabarito: _gabarito,
      );
      try {
        await _apiService.updateProva(provaToSave);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prova atualizada com sucesso!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar prova: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _dataController.dispose();
    _novaQuestaoNumeroController.dispose();
    _novaQuestaoRespostaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.prova == null ? 'Cadastrar Prova' : 'Editar Prova',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título da Prova',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dataController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: 'Data da Prova',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a data';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _isLoadingDropdowns
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<TurmaDTO>(
                value: _selectedTurma,
                decoration: InputDecoration(
                  labelText: 'Turma',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _turmas.map((TurmaDTO turma) {
                  return DropdownMenuItem<TurmaDTO>(
                    value: turma,
                    child: Text(turma.nome),
                  );
                }).toList(),
                onChanged: (TurmaDTO? newValue) {
                  setState(() {
                    _selectedTurma = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione a turma';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _isLoadingDropdowns
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<DisciplinaDTO>(
                value: _selectedDisciplina,
                decoration: InputDecoration(
                  labelText: 'Disciplina',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _disciplinas.map((DisciplinaDTO disciplina) {
                  return DropdownMenuItem<DisciplinaDTO>(
                    value: disciplina,
                    child: Text(disciplina.nome),
                  );
                }).toList(),
                onChanged: (DisciplinaDTO? newValue) {
                  setState(() {
                    _selectedDisciplina = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione a disciplina';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<Bimestre>(
                value: _selectedBimestre,
                decoration: InputDecoration(
                  labelText: 'Bimestre',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: Bimestre.values.map((Bimestre bimestre) {
                  return DropdownMenuItem<Bimestre>(
                    value: bimestre,
                    child: Text(bimestre.toDisplayString()),
                  );
                }).toList(),
                onChanged: (Bimestre? newValue) {
                  setState(() {
                    _selectedBimestre = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione o bimestre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Text(
                'Gabarito da Prova',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _novaQuestaoNumeroController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Nº Questão',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _novaQuestaoRespostaController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 5,
                      decoration: InputDecoration(
                        labelText: 'Resposta Correta',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addQuestao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _gabarito.isEmpty
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'Nenhuma questão adicionada ao gabarito.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
                  : Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _gabarito.length,
                  itemBuilder: (context, index) {
                    final questao = _gabarito[index];
                    return ListTile(
                      title: Text('Questão ${questao.numeroQuestao}'),
                      subtitle: Text('Resposta: ${questao.respostaCorreta}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _removeQuestao(index),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveProva,
                icon: const Icon(Icons.save),
                label: Text(widget.prova == null ? 'Salvar Prova' : 'Atualizar Prova'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}