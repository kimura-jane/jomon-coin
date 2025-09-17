
# JOMON COIN Starter (Polygon / 転送不可 + migrate)

- Owner (あなたのウォレット): 0x8242dAe5C6fF90b03d15C54Cad95C3ed97AC0571
- Token address: デプロイ後に `index.html` の `TOKEN_ADDRESS` を差し替え
- Distributor: 配布開始時に差し替え

## 手順（最短 / Remix）
1. MetaMaskを Polygon(137) に切替、少額 POL を用意。
2. https://remix.ethereum.org を開き、`JomonCoin.sol` を新規作成して本リポの内容をコピペ。
3. Compiler: Solidity 0.8.24 / Optimization 200 → Compile。
4. Deploy & Run: Injected Provider – MetaMask / Network: Polygon(137) → Deploy。
5. 出たコントラクトアドレスを `index.html` の `TOKEN_ADDRESS` に貼る。GitHub Pages等に配置。
6. Polygonscanで Verify & Publish（0.8.24 / 最適化ON）。

## 使い方
- **MetaMaskに追加**: サイトのボタンでロゴ付き追加。
- **残高表示**: サイトの残高ボタン。
- **migrate**: 本人の新アドレスへ移行（burn→mint）。
- **配布（後日）**: `claims.json` を埋めて Distributorをデプロイ → `MINTER_ROLE` をDistributorに付与 → サイトでClaim。

## セキュリティ
- 管理権限（DEFAULT_ADMIN_ROLE）は Safe に移譲推奨。
- MINTER_ROLE は配布時のみ付与し、終わったら revoke。
- 規約に「譲渡不可・売買不可・投機性なし・再発行手順」を明記。
