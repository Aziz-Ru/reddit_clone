# reddit

A new Flutter project.

                    final community = communities[index];
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(
                                        context, community.name),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.borderColor)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            community.avatar),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        community.name,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${community.members.length} members',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                              softWrap: true,
                                              communities[index].description),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 10,
                                      child: community.mods.contains(user.uid)
                                          ? OutlinedButton(
                                              onPressed: () =>
                                                  navigateToModTools(
                                                      context, community.name),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                              child: const Text('Mod Tools'))
                                          : OutlinedButton(
                                              onPressed: () =>
                                                  joinOrLeaveCommunity(
                                                      ref, context, community),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                              child: Text(community.members
                                                      .contains(user.uid)
                                                  ? 'Leave'
                                                  : 'Join')))
                                ],
                              );
