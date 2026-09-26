const jwt=require('jsonwebtoken');
function authRequired(req,res,next){try{const h=req.headers.authorization||''; if(!h.startsWith('Bearer ')) return res.status(401).json({error:'Authentication required'}); req.user=jwt.verify(h.slice(7),process.env.JWT_SECRET); next();}catch(e){res.status(401).json({error:'Invalid or expired token'});}}
module.exports={authRequired};
