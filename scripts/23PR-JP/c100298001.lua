--外毒多头蛇
--Script by 奥克斯
function c100298001.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c100298001.fsilter,2,63,true)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c100298001.atktg)
	e1:SetValue(c100298001.atkval)
	c:RegisterEffect(e1)
	--material check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c100298001.regcon)
	e2:SetOperation(c100298001.regop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100298001,5))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c100298001.drcon)
	e3:SetTarget(c100298001.drtg)
	e3:SetOperation(c100298001.drop)
	c:RegisterEffect(e3)
end
function c100298001.fsilter(c,fc)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsOnField() and c:IsControler(fc:GetControler())
end
function c100298001.checkfilter(c,rtype)
	return c:IsType(rtype)
end
function c100298001.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c100298001.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g==0 or c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
	if g:IsExists(c100298001.checkfilter,1,nil,TYPE_FUSION) and c:GetFlagEffect(100298001)==0 then
		c:RegisterFlagEffect(100298001,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100298001,0))
		--提示用flag
	end
	if g:IsExists(c100298001.checkfilter,1,nil,TYPE_SYNCHRO) and c:GetFlagEffect(100298001+100)==0 then
		c:RegisterFlagEffect(100298001+100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100298001,1))
		--提示用flag
	end
	if g:IsExists(c100298001.checkfilter,1,nil,TYPE_XYZ) and c:GetFlagEffect(100298001+200)==0 then
		c:RegisterFlagEffect(100298001+200,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100298001,2))
		--提示用flag
	end
	if g:IsExists(c100298001.checkfilter,1,nil,TYPE_PENDULUM) and c:GetFlagEffect(100298001+300)==0 then
		c:RegisterFlagEffect(100298001+300,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100298001,3))
		--提示用flag
	end
	if g:IsExists(c100298001.checkfilter,1,nil,TYPE_LINK) and c:GetFlagEffect(100298001+400)==0 then
		c:RegisterFlagEffect(100298001+400,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100298001,4))
		--提示用flag
	end   
end
function c100298001.atktg(e,c)
	local ec=e:GetHandler()
	local b1=ec:GetFlagEffect(100298001)>0 and c:IsType(TYPE_FUSION)
	local b2=ec:GetFlagEffect(100298001+100)>0 and c:IsType(TYPE_SYNCHRO)
	local b3=ec:GetFlagEffect(100298001+200)>0 and c:IsType(TYPE_XYZ)
	local b4=ec:GetFlagEffect(100298001+300)>0 and c:IsType(TYPE_PENDULUM)
	local b5=ec:GetFlagEffect(100298001+400)>0 and c:IsType(TYPE_LINK)
	return c:IsFaceup() and (b1 or b2 or b3 or b4 or b5)
end
function c100298001.atkval(e,c)
	return -c:GetBaseAttack()
end
function c100298001.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and ev>=1000
end
function c100298001.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=math.floor(ev/1000)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,val) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,val)
end
function c100298001.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end