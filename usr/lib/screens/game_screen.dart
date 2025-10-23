import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/question.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.level});
  final String level;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentQuestionIndex = 0;
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    // Exemplo de questões hardcoded - em produção, poderia vir de API ou banco
    if (widget.level == 'Básico') {
      questions = [
        Question(
          question: 'O que é débito?',
          options: ['Entrada de dinheiro', 'Saída de dinheiro', 'Ambos'],
          correctAnswer: 0,
          explanation: 'Débito representa entrada de recursos, como receitas.',
        ),
        Question(
          question: 'Balanceie: Receitas \$ 1000, Despesas \$ 800. Lucro?',
          options: ['\$ 200', '\$ 1200', '\$ 800'],
          correctAnswer: 0,
          explanation: 'Lucro = Receitas - Despesas = 1000 - 800 = 200.',
        ),
      ];
    } else if (widget.level == 'Intermediário') {
      questions = [
        Question(
          question: 'O que é ativo circulante?',
          options: ['Bens de longo prazo', 'Dinheiro e contas a receber', 'Passivos'],
          correctAnswer: 1,
          explanation: 'Ativo circulante são recursos que se convertem em dinheiro rapidamente.',
        ),
      ];
    } else {
      questions = [
        Question(
          question: 'Como calcular o ROI?',
          options: ['Lucro / Investimento', 'Investimento / Lucro', 'Lucro - Investimento'],
          correctAnswer: 0,
          explanation: 'ROI = (Lucro / Investimento) x 100, mede eficiência do investimento.',
        ),
      ];
    }
  }

  void _answerQuestion(int selectedIndex) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final currentQuestion = questions[currentQuestionIndex];

    if (selectedIndex == currentQuestion.correctAnswer) {
      gameProvider.addScore(10);
      _showFeedback('Correto! ${currentQuestion.explanation}', Colors.green);
    } else {
      _showFeedback('Errado. ${currentQuestion.explanation}', Colors.red);
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() => currentQuestionIndex++);
    } else {
      _showGameOver();
    }
  }

  void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fim do Jogo!'),
        content: Text('Sua pontuação final: ${Provider.of<GameProvider>(context).score}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Voltar ao Início'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const CircularProgressIndicator();

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Nível: ${widget.level}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.asMap().entries.map((entry) {
              return ElevatedButton(
                onPressed: () => _answerQuestion(entry.key),
                child: Text(entry.value),
              );
            }),
          ],
        ),
      ),
    );
  }
}