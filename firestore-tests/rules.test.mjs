// Checks firestore.rules against the local emulator. Run with: npm test
import { initializeTestEnvironment, assertSucceeds, assertFails } from '@firebase/rules-unit-testing';
import { doc, getDoc, runTransaction, setDoc, updateDoc, serverTimestamp } from 'firebase/firestore';
import { readFileSync } from 'node:fs';

const env = await initializeTestEnvironment({
  projectId: 'demo-fft',
  firestore: { rules: readFileSync(new URL("../firestore.rules", import.meta.url), "utf8"), host: '127.0.0.1', port: 8080 },
});
const profile = (handle, extra = {}) => ({ displayName: 'Josh Langwell', handle, photoUrl: null, bio: '',
  createdAt: serverTimestamp(), favourites: [], followerCount: 0, followingCount: 0, reviewCount: 0, ...extra });
const create = (db, uid, handle, extra) => runTransaction(db, async tx => {
  await tx.get(doc(db, 'users', uid)); await tx.get(doc(db, 'handles', handle));
  tx.set(doc(db, 'handles', handle), { uid }); tx.set(doc(db, 'users', uid), profile(handle, extra));
});
let ok = 0, bad = 0;
const check = async (name, p) => { try { await p; ok++; console.log('PASS', name); } catch (e) { bad++; console.log('FAIL', name, e.message); } };

const josh = env.authenticatedContext('josh').firestore();
const sam = env.authenticatedContext('sam').firestore();
const anon = env.unauthenticatedContext().firestore();

await check('Josh creates his profile + handle', assertSucceeds(create(josh, 'josh', 'josh_langwell')));
await check('Sam cannot steal josh_langwell', assertFails(create(sam, 'sam', 'josh_langwell')));
await check('Sam cannot write Josh\'s profile', assertFails(updateDoc(doc(sam, 'users', 'josh'), { bio: 'hi' })));
await check('Sam cannot start with fake counts', assertFails(create(sam, 'sam', 'sam_x', { reviewCount: 99 })));
await check('Sam cannot create profile without handle doc', assertFails(setDoc(doc(sam, 'users', 'sam'), profile('sam_y'))));
await check('Sam creates his own profile', assertSucceeds(create(sam, 'sam', 'sam_lee')));
await check('Signed-in users can read profiles', assertSucceeds(getDoc(doc(sam, 'users', 'josh'))));
await check('Signed-out cannot read', assertFails(getDoc(doc(anon, 'users', 'josh'))));
await check('Josh edits his bio', assertSucceeds(updateDoc(doc(josh, 'users', 'josh'), { bio: 'Eats out a lot' })));
await check('Josh cannot change handle', assertFails(updateDoc(doc(josh, 'users', 'josh'), { handle: 'jl' })));
await check('Other collections are closed', assertFails(setDoc(doc(josh, 'restaurants', 'r1'), { name: 'x' })));
await env.cleanup();
console.log(`${ok} passed, ${bad} failed`); process.exit(bad ? 1 : 0);
