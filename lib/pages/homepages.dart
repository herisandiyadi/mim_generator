import 'package:algo_test/cubit/mim_generator_cubit.dart';
import 'package:algo_test/pages/detail_mim_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  @override
  void initState() {
    super.initState();
    context.read<MimGeneratorCubit>().getMim();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            margin: const EdgeInsets.all(24),
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<MimGeneratorCubit>().getMim();
              },
              child: ListView(
                children: [
                  const Center(
                    child: Text(
                      'MIM Generator',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BlocBuilder<MimGeneratorCubit, MimGeneratorState>(
                    builder: (context, state) {
                      if (state is MimGeneratorLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is MimGeneratorLoaded) {
                        final data = state.mimModel.data.memes;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  // banyak grid yang ditampilkan dalam satu baris
                                  crossAxisCount: 3),
                          itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailMimPage(
                                        data: data[index],
                                      )));
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(data[index].url),
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount: data.length,
                        );
                      } else if (state is MimGeneratorFailed) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return const Center(
                          child: Text('No Data'),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
