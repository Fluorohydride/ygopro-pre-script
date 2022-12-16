--超重天神マスラ－O
--Script by 奥克斯
function c101112039.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101112039.reptg)
	e2:SetValue(c101112039.repval)
	e2:SetOperation(c101112039.repop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112039,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101112039.drcon)
	e3:SetTarget(c101112039.drtg)
	e3:SetOperation(c101112039.drop)
	c:RegisterEffect(e3)
end
function c101112039.filter1(c,tp)
	return not c:IsReason(REASON_REPLACE) and  c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x9a) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c101112039.filter2(c,e)
	if c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED+STATUS_BATTLE_RESULT) then return false end
	return c:IsSetCard(0x9a) and c:IsDestructable(e)
end
function c101112039.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c101112039.filter1,nil,tp)
	local tg=Duel.GetMatchingGroup(c101112039.filter2,tp,LOCATION_ONFIELD,0,nil,e)
	if chk==0 then return #g>0 and #tg>0 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local xg=tg:Select(tp,1,1,nil)
		Duel.SetTargetCard(xg)
		return true
	else return false end
end
function c101112039.repval(e,c)
	return c101112039.filter1(c,e:GetHandlerPlayer())
end
function c101112039.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101112039)
	local tc=Duel.GetFirstTarget()
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end

function c101112039.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c101112039.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		return h<3 and Duel.IsPlayerCanDraw(tp,3-h)
	end
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3-h)
end
function c101112039.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local h=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if h>=3 then return end
	Duel.Draw(p,3-h,REASON_EFFECT)
end