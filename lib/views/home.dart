import 'package:flutter/material.dart';
import 'package:frest/models/repos_model.dart';
import 'package:frest/models/token_model.dart';
import 'package:frest/utils/margin.dart';
import 'package:frest/widgets/loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frest/utils/theme.dart';
import 'package:frest/view_models/home_vm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends StatefulHookConsumerWidget {
  final TokenModel? tokenModel;
  const HomePage({Key? key, this.tokenModel}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final providerMain = StateNotifierProvider((ref) => HomeViewModel());

  @override
  void initState() {
    ref
        .read(providerMain.notifier)
        .getRepos(context, widget.tokenModel!.accessToken!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(providerMain.notifier);
    return Scaffold(
      backgroundColor: bgColor,
      body: !provider.isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const YMargin(y: 70),
                  Text('Your Repos',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: white,
                          fontSize: 23,
                        ),
                      )),
                  const YMargin(y: 20),
                  Flexible(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        const YMargin(y: 30),
                        if (provider.reposModel != null &&
                            provider.reposModel!.data!.isNotEmpty)
                          for (var item in provider.reposModel!.data!)
                            RepoWidget(repoItem: item)
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Loader(),
    );
  }
}

class RepoWidget extends StatelessWidget {
  const RepoWidget({Key? key, this.repoItem}) : super(key: key);

  final ReposModel? repoItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth(0.8),
      padding: const EdgeInsets.only(
        left: 30,
        top: 30,
        right: 15,
        bottom: 20,
      ),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
          color: darkGrey, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repoItem?.name ?? '',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: white,
                fontSize: 19,
              ),
            ),
          ),
          const YMargin(y: 7),
          Text(
            repoItem?.htmlUrl ?? '',
            style: GoogleFonts.sourceCodePro(
              textStyle: TextStyle(
                fontWeight: FontWeight.w300,
                color: white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
          const YMargin(y: 20),
          Text(
            repoItem?.description ?? '',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                color: white,
                fontSize: 14,
              ),
            ),
          ),
          const YMargin(y: 30),
          Row(
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    color: red,
                    child: Text(
                      repoItem?.language ?? '',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const XMargin(x: 20),
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    color: primary,
                    child: Text(
                      repoItem?.license?.name ?? '',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
