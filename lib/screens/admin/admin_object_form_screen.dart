// lib/screens/admin/admin_object_form_screen.dart
import 'package:flutter/material.dart';
import '../../../models/usuario_dto.dart';
import '../../../services/api_service.dart';
import '../../../models/turma_dto.dart';
import '../../../models/disciplina_dto.dart';

enum AdminFormObjectType { user, discipline, class_ } // Adicionado class_ (turma)

class AdminObjectFormScreen extends StatefulWidget {
  final AdminFormObjectType objectType;
  final dynamic initialObject; // Pode ser UsuarioDTO, DisciplinaDTO ou TurmaDTO

  const AdminObjectFormScreen({
    super.key,
    required this.objectType,
    this.initialObject,
  });

  @override
  State<AdminObjectFormScreen> createState() => _AdminObjectFormScreenState();
}

class _AdminObjectFormScreenState extends State<AdminObjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _periodoController; // Para Turma
  late TextEditingController _cursoController; // Para Turma

  // For User form
  String? _selectedPerfil;
  List<TurmaDTO> _turmas = [];
  TurmaDTO? _selectedTurma;
  bool _isLoadingTurmas = true;
  final List<String> _perfis = ['ADMINISTRADOR', 'PROFESSOR', 'ALUNO'];

  // For Discipline form
  UsuarioDTO? _selectedProfessor;
  List<UsuarioDTO> _professors = [];
  bool _isLoadingProfessors = true;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _periodoController = TextEditingController();
    _cursoController = TextEditingController();

    if (widget.objectType == AdminFormObjectType.user) {
      final UsuarioDTO? user = widget.initialObject as UsuarioDTO?;
      _nameController.text = user?.nome ?? '';
      _emailController.text = user?.email ?? '';
      _selectedPerfil = user?.perfil;
      _fetchTurmasData();
    } else if (widget.objectType == AdminFormObjectType.discipline) {
      final DisciplinaDTO? discipline = widget.initialObject as DisciplinaDTO?;
      _nameController.text = discipline?.nome ?? '';
      _fetchProfessorsData();
    } else if (widget.objectType == AdminFormObjectType.class_) {
      final TurmaDTO? classObject = widget.initialObject as TurmaDTO?;
      _nameController.text = classObject?.nome ?? '';
      _periodoController.text = classObject?.periodo ?? '';
      _cursoController.text = classObject?.curso ?? '';
    }
  }

  Future<void> _fetchTurmasData() async {
    try {
      final fetchedTurmas = await _apiService.fetchTurmasAdmin(); // Usar o novo fetch para turmas admin
      setState(() {
        _turmas = fetchedTurmas;
        _isLoadingTurmas = false;

        final UsuarioDTO? user = widget.initialObject as UsuarioDTO?;
        if (_turmas.isNotEmpty && user != null && user.perfil == 'ALUNO' && user.turmaId != null) {
          _selectedTurma = _turmas.firstWhere(
                (turma) => turma.id == user.turmaId,
          );
        } else {
          _selectedTurma = null;
        }
      });
    } catch (e, stackTrace) {
      setState(() {
        _isLoadingTurmas = false;
      });
      debugPrint('Erro ao carregar turmas: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar turmas: $e')),
      );
    }
  }

  Future<void> _fetchProfessorsData() async {
    try {
      final allUsers = await _apiService.fetchUsuarios();
      setState(() {
        _professors = allUsers.where((u) => u.perfil == 'PROFESSOR').toList();
        _isLoadingProfessors = false;

        final DisciplinaDTO? discipline = widget.initialObject as DisciplinaDTO?;
        if (_professors.isNotEmpty && discipline != null && discipline.professorId != null) {
          _selectedProfessor = _professors.firstWhere(
                (prof) => prof.id == discipline.professorId,
          );
        } else {
          _selectedProfessor = null;
        }
      });
    } catch (e, stackTrace) {
      setState(() {
        _isLoadingProfessors = false;
      });
      debugPrint('Erro ao carregar professores: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar professores: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _periodoController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  Future<void> _saveObject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      if (widget.objectType == AdminFormObjectType.user) {
        final String nome = _nameController.text;
        final String email = _emailController.text;
        final String senha = _passwordController.text;
        final String perfil = _selectedPerfil!;

        UsuarioDTO userToSave;
        int? turmaIdToSend;

        if (perfil == 'ALUNO') {
          turmaIdToSend = _selectedTurma?.id;
        }

        if (widget.initialObject == null) {
          userToSave = UsuarioDTO(
            nome: nome,
            email: email,
            senha: senha,
            perfil: perfil,
            turmaId: turmaIdToSend,
          );
          await _apiService.addUsuario(userToSave);
        } else {
          final UsuarioDTO existingUser = widget.initialObject as UsuarioDTO;
          userToSave = UsuarioDTO(
            id: existingUser.id,
            nome: nome,
            email: email,
            senha: senha.isEmpty ? null : senha,
            perfil: perfil,
            turmaId: turmaIdToSend,
          );
          await _apiService.updateUsuario(userToSave);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário ${widget.initialObject == null ? "adicionado" : "atualizado"} com sucesso!')),
        );
      } else if (widget.objectType == AdminFormObjectType.discipline) {
        final String nome = _nameController.text;
        final int? professorId = _selectedProfessor?.id;

        if (professorId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, selecione um professor responsável.')),
          );
          return;
        }

        DisciplinaDTO disciplineToSave;
        if (widget.initialObject == null) {
          disciplineToSave = DisciplinaDTO(
            nome: nome,
            professorId: professorId,
          );
          await _apiService.addDisciplina(disciplineToSave);
        } else {
          final DisciplinaDTO existingDiscipline = widget.initialObject as DisciplinaDTO;
          disciplineToSave = DisciplinaDTO(
            id: existingDiscipline.id,
            nome: nome,
            professorId: professorId,
          );
          await _apiService.updateDisciplina(disciplineToSave);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Disciplina ${widget.initialObject == null ? "adicionada" : "atualizada"} com sucesso!')),
        );
      } else if (widget.objectType == AdminFormObjectType.class_) {
        final String nome = _nameController.text;
        final String periodo = _periodoController.text;
        final String curso = _cursoController.text;

        TurmaDTO classToSave;
        if (widget.initialObject == null) {
          classToSave = TurmaDTO(
            nome: nome,
            periodo: periodo,
            curso: curso,
            id: null, // ID é gerado pelo backend
          );
          await _apiService.addTurma(classToSave);
        } else {
          final TurmaDTO existingClass = widget.initialObject as TurmaDTO;
          classToSave = TurmaDTO(
            id: existingClass.id,
            nome: nome,
            periodo: periodo,
            curso: curso,
          );
          await _apiService.updateTurma(classToSave);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Turma ${widget.initialObject == null ? "adicionada" : "atualizada"} com sucesso!')),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (widget.objectType == AdminFormObjectType.user) {
      appBarTitle = widget.initialObject == null ? 'Adicionar Usuário' : 'Editar Usuário';
    } else if (widget.objectType == AdminFormObjectType.discipline) {
      appBarTitle = widget.initialObject == null ? 'Adicionar Disciplina' : 'Editar Disciplina';
    } else {
      appBarTitle = widget.initialObject == null ? 'Adicionar Turma' : 'Editar Turma';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
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
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: widget.objectType == AdminFormObjectType.user
                      ? 'Nome'
                      : (widget.objectType == AdminFormObjectType.discipline
                      ? 'Nome da Disciplina'
                      : 'Nome da Turma'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              if (widget.objectType == AdminFormObjectType.user) ...[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o e-mail';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: widget.initialObject == null ? 'Senha' : 'Senha (deixe em branco para manter a atual)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (widget.initialObject == null && (value == null || value.isEmpty)) {
                      return 'Por favor, insira a senha para um novo usuário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedPerfil,
                  decoration: InputDecoration(
                    labelText: 'Perfil',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _perfis.map((String perfil) {
                    return DropdownMenuItem<String>(
                      value: perfil,
                      child: Text(perfil),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPerfil = newValue;
                      if (newValue != 'ALUNO') {
                        _selectedTurma = null;
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um perfil';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                if (_selectedPerfil == 'ALUNO')
                  _isLoadingTurmas
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<TurmaDTO>(
                    value: _selectedTurma,
                    decoration: InputDecoration(
                      labelText: 'Associar Turma',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _turmas.map((TurmaDTO turma) {
                      return DropdownMenuItem<TurmaDTO>(
                        value: turma,
                        child: Text('${turma.nome} - ${turma.curso}'),
                      );
                    }).toList(),
                    onChanged: (TurmaDTO? newValue) {
                      setState(() {
                        _selectedTurma = newValue;
                      });
                    },
                    validator: (value) {
                      if (_selectedPerfil == 'ALUNO' && value == null) {
                        return 'Por favor, selecione uma turma para o aluno';
                      }
                      return null;
                    },
                  ),
              ] else if (widget.objectType == AdminFormObjectType.discipline) ...[
                _isLoadingProfessors
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<UsuarioDTO>(
                  value: _selectedProfessor,
                  decoration: InputDecoration(
                    labelText: 'Professor Responsável',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _professors.map((UsuarioDTO professor) {
                    return DropdownMenuItem<UsuarioDTO>(
                      value: professor,
                      child: Text(professor.nome),
                    );
                  }).toList(),
                  onChanged: (UsuarioDTO? newValue) {
                    setState(() {
                      _selectedProfessor = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione um professor';
                    }
                    return null;
                  },
                ),
              ] else if (widget.objectType == AdminFormObjectType.class_) ...[
                TextFormField(
                  controller: _periodoController,
                  decoration: InputDecoration(
                    labelText: 'Período',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o período';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _cursoController,
                  decoration: InputDecoration(
                    labelText: 'Curso',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o curso';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveObject,
                icon: const Icon(Icons.save),
                label: Text(widget.initialObject == null ? 'Salvar' : 'Atualizar'),
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