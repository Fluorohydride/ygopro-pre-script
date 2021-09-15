--相剑大邪—七星龙渊
function c101107041.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WYRM),1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107041,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101107041)
	e1:SetCondition(c101107041.drcon)
	e1:SetTarget(c101107041.drtg)
	e1:SetOperation(c101107041.drop)
	c:RegisterEffect(e1)
	--remove monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107041,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,101107041+100)
	e2:SetTarget(c101107041.remtg1)
	e2:SetOperation(c101107041.remop1)
	c:RegisterEffect(e2)
	--remove spell/trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107041,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101107041+200)
	e3:SetCondition(c101107041.remcon2)
	e3:SetTarget(c101107041.remtg2)
	e3:SetOperation(c101107041.remop2)
	c:RegisterEffect(e3)
end
function c101107041.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:IsSummonType(SUMMON_TYPE_SYNCHRO) and tg:IsSummonPlayer(tp)
end
function c101107041.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101107041.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101107041.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsOnField()
end
function c101107041.remtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101107041.filter,1,nil,tp) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c101107041.filter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c101107041.remop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101107041.filter,nil,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
function c101107041.remcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c101107041.remtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c101107041.remop2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		if Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
			 Duel.Damage(1-tp,1200,REASON_EFFECT)
		end
	end
end
