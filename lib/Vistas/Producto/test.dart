import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatelessWidget {
  final List<String> _dataList = ['Flutter', 'Dart', 'Widgets', 'UI'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Búsqueda'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Buscar'),
          onPressed: () async {
            final String? result = await showSearch(
              context: context,
              delegate: DataSearch(dataList: _dataList),
            );
            print('Resultado de búsqueda: $result');
          },
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<String> dataList;

  DataSearch({required this.dataList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> results =
        dataList.where((item) => item.contains(query)).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = query.isEmpty
        ? dataList
        : dataList.where((item) => item.contains(query)).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField({super.key});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final List<String> _relatedSearches = ['Flutter', 'Dart', 'Widgets', 'UI'];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Buscar',
            ),
            onChanged: (value) {
              setState(
                  () {}); // Redibujar para mostrar los resultados actualizados
            },
          ),
          const SizedBox(
              height:
                  16), // Espacio para separar el TextField de los resultados
          ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Deshabilitar el desplazamiento de la lista
            itemCount: _relatedSearches.length,
            itemBuilder: (BuildContext context, int index) {
              final relatedSearch = _relatedSearches[index];
              if (relatedSearch
                  .toLowerCase()
                  .contains(_textEditingController.text.toLowerCase())) {
                return ListTile(
                  title: Text(relatedSearch),
                  onTap: () {
                    // Acción a realizar cuando el usuario toca un resultado
                  },
                );
              } else {
                return Container(); // Devolver un widget vacío si no hay coincidencia
              }
            },
          ),
        ],
      ),
    );
  }
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final name = reader.read() as String;
    final price = reader.read() as double;
    return Product(name: name, price: price);
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.write(obj.name);
    writer.write(obj.price);
  }
}

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  Product({required this.name, required this.price});
}

class MultipleDelete extends StatefulWidget {
  @override
  _MultipleDeleteState createState() => _MultipleDeleteState();
}

class _MultipleDeleteState extends State<MultipleDelete> {
  late Box<Product> _productsBox;
  List<Product> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _productsBox = Hive.box<Product>('products');
  }

  void _onSelectProduct(Product product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
    });
  }

  void _onDeleteSelected() async {
    setState(() {
      _selectedProducts.forEach((product) => product.delete());
      _selectedProducts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar varios productos'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _productsBox.listenable(),
        builder: (context, Box<Product> box, _) {
          final products = box.values.toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isSelected = _selectedProducts.contains(product);
              return ListTile(
                onTap: () => _onSelectProduct(product),
                leading: isSelected
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onDeleteSelected,
        child: Icon(Icons.delete),
      ),
    );
  }
}

class delete extends StatefulWidget {
  const delete({super.key});

  @override
  _deleteState createState() => _deleteState();
}

class _deleteState extends State<delete> {
  List<String> _items = [
    'Widget 1',
    'Widget 2',
    'Widget 3',
    'Widget 4',
    'Widget 5',
  ];
  List<String> _selectedItems = [];

  void _onSelectItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _onDeleteSelected() {
    setState(() {
      _items.removeWhere((item) => _selectedItems.contains(item));
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar varios widgets'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final isSelected = _selectedItems.contains(item);
          return ListTile(
            onTap: () => _onSelectItem(item),
            leading: isSelected
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
            title: Text(item),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onDeleteSelected,
        child: Icon(Icons.delete),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String displayText = '';

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        displayText = '';
      } else if (buttonText == '=') {
        displayText = evalExpression(displayText);
      } else {
        displayText += buttonText;
      }
    });
  }

  String evalExpression(String expression) {
    try {
      // evaluar la expresión matemática usando la librería de 'math_expressions'
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.all(20.0),
        ),
        //color: buttonColor,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        onPressed: () => buttonPressed(buttonText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: Text(
                  displayText,
                  style: TextStyle(fontSize: 50.0),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                buildButton('7', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('8', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('9', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('/', Colors.orange),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                buildButton('4', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('5', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('6', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('*', Colors.orange),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                buildButton('1', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('2', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('3', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('-', Colors.orange),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                buildButton('0', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('.', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('C', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('+', Colors.orange),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                buildButton('(', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton(')', Colors.grey[400]!),
                const SizedBox(width: 10.0),
                buildButton('^', Colors.orange),
                const SizedBox(width: 10.0),
                buildButton('=', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
